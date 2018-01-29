namespace Quantum.BB84
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Set (desired: Result, q1: Qubit) : ()
    {
        body
        {
            // Measure the qubit
            let current = M(q1);

            // If the Qubit is not the desired one,
            // operate NOT
			if (desired != current)
			{
				X(q1);
			}
        }
    }

    operation EPRPair (q1: Qubit, q2: Qubit) : ()
    {
        body
        {
            Set(Zero, q1);
            Set(Zero, q2);

            H(q1);
            CNOT(q1, q2);
        }
    }

    operation RotateDirection (q1: Qubit) : ()
    {
        body
        {
            H(q1);
        }
    }

    // direction: True if direction1, False otherwise
    operation Alice (q1: Qubit, q2: Qubit, direction: Bool) : (Result)
    {
        body
        {
            EPRPair(q1, q2);

            if (!direction)
            {
                RotateDirection(q1);
            }

            return M(q1);
        }
    }

    operation Bob (q2: Qubit, direction: Bool) : (Result)
    {
        body
        {
            if (!direction)
            {
                RotateDirection(q2);
            }

            return M(q2);
        }
    }

    operation Carol (q2: Qubit) : ()
    {
        body
        {
            let r = M(q2);

            if (r == One)
            {
                Z(q2);
            }
        }
    }

    operation IsIdenticalOnExchange (aliceDirection: Bool, bobDirection: Bool, withCarol: Bool) : (Bool)
    {
        body
        {
            mutable identical = false;
            using (qubits = Qubit[2])
            {
                let aliceResult = Alice(qubits[0], qubits[1], aliceDirection);

                if (withCarol)
                {
                    Carol(qubits[1]);
                }

                let bobResult = Bob(qubits[1], bobDirection);

                if (aliceResult == bobResult)
                {
                    set identical = true;
                }

                Set(Zero, qubits[0]);
                Set(Zero, qubits[1]);
            }

            return identical;
        }
    }
}
