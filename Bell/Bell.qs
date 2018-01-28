namespace Quantum.Bell
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

	operation BellTest (count: Int, initial: Result) : (Int, Int)
	{
		body
		{
			mutable numOnes = 0;

			using (qubits = Qubit[1])
			{
				for (test in 1..count)
				{
					Set(initial, qubits[0]);

					let res = M(qubits[0]);

					if (res == One)
					{
						set numOnes = numOnes + 1;
					}
				}

				Set(Zero, qubits[0]);
			}

			return (count - numOnes, numOnes);
		}
	}
}
