using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.BB84
{
    class Driver
    {
        static (int, int) Simulation(QuantumSimulator sim, int count, bool withEve)
        {
            var random = new System.Random();

            var sameDirectionNum = 0;
            var identicalNum = 0;

            for (var i = 0; i < count; i++)
            {
                var aliceDirection = random.Next(2) == 0;
                var bobDirection = random.Next(2) == 0;

                if (aliceDirection == bobDirection)
                {
                    sameDirectionNum++;
                }

                var identical = IsIdenticalOnExchange.Run(sim, aliceDirection, bobDirection, withEve).Result;

                if (aliceDirection == bobDirection && identical)
                {
                    identicalNum++;
                }
            }

            return (sameDirectionNum, identicalNum);
        }

        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                int[] tries = { 1, 2, 5, 10, 15, 20, 25, 100 };

                foreach (var t in tries)
                {
                    System.Console.WriteLine($"Trial: {t}");
                    var (s1, i1) = Simulation(sim, t, false);
                    System.Console.WriteLine($"Without Eve: same direction = {s1} identical = {i1}");

                    var (s2, i2) = Simulation(sim, t, true);
                    System.Console.WriteLine($"With Eve: same direction = {s2} identical = {i2}");
                }
            }

            System.Console.WriteLine("Press any key to continue...");
            System.Console.ReadKey();
        }
    }
}