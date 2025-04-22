## DESCRIPTION
-------------------------

This project is a  framework to test and compare different solvers for the Traveling Salesman Problem (TSP). 
It helps generate test instances, convert input formats, run solvers (both CPU and GPU-based). 
It is designed for academic use and accessible to everyone in academia.

## SCRIPTS:
-------------------------

All necessary shell scripts for running solvers, generating instances, converting formats, and cleaning up are stored in the `scripts/` folder. 
Solver runners include those for Concorde, LKH, GPU-based ACS, and GPU PIHC. Instance generators include scripts for DIMACS-style and Hougardy-Zhong (Tnm) instances. 
There are also Python-based converters to convert GEO to EUC_2D and EUC_2D to FULL_MATRIX. Cleanup scripts are provided to delete generated solutions or test sets.

## CONVERTERS:
-------------------------

GEO to EUC_2D conversion is required for GPU solvers like ACS and PIHC. 
These solvers only accept Euclidean coordinates, so any TSP file with GEO format must be converted before use. 
The converter `geo2euc_converter.py` handles this task, and is typically run through an script that allows you to choose the type of conversion.

Some solvers or tools may require a full distance matrix rather than coordinates. 
In such cases, EUC_2D files can be converted to FULL_MATRIX format using `euc2fullmatrix_converter.py`.

To streamline usage, there is a unified script that prompts the user to select one of the following options:
1. GEO → EUC_2D
2. EUC_2D → FULL_MATRIX
3. Run both conversions sequentially

This is handled via `run_converters.sh`, which calls the relevant Python converters interactively based on user input.

## GENERATORS
-------------------------

The framework has two types of instance generators. `generate_dimacs_instances.sh` produces random TSP instances based on the DIMACS challenge format. 
These are useful for testing general performance.

`generate_tnm_instances.sh` produces hard-to-solve TSP instances following the Tnm model described by Hougardy and Zhong. 
These are valuable for stress testing solvers. Both instance types are saved in the appropriate benchmark folders and can be removed using their respective delete scripts.

## SOLVERS:
-------------------------

Concorde is an exact solver that can process both GEO and EUC\_2D instances. 
It outputs solution files (`.sol`) and moves them into a cleaned `tours/concorde_tours` directory. Temporary files are automatically deleted.

LKH is a heuristic solver that can support multiple salesmen (mTSP). 
It accepts known or unknown instances in any format. Users can specify strategies in the `.par` file. It outputs `.tour` files and logs.

GPU ACS uses a parallel version of Ant Colony System. It only accepts EUC\_2D files. 
Before using this solver, ensure GEO files are converted. Outputs are saved in JSON format.

GPU PIHC is a CUDA-based heuristic. It requires the user to select both an initialization strategy and a CUDA thread mapping style. 
Like ACS, it only accepts EUC\_2D input files and produces `.sol` output files.

## USAGE:
-------------------------

Before running any solver, make sure to read the README of that solver and generator then compile or configure it if necessary.
Then, generate test instances using the provided generator scripts.

You can also add your own TSP instances to the benchmark folders. 
Just make sure they follow the correct TSPLIB format and are placed in the right directories (e.g., opt_known_euc or opt_unknown_euc).

Convert any GEO files to EUC_2D using the appropriate converter. Optionally, convert EUC_2D to FULL_MATRIX if needed.

Once data is ready, use the run scripts for each solver.
Each script handles output placement. After running, use the cleanup scripts to delete intermediate and solution files.

Example workflow:
./generate_dimacs_instances.sh
./generate_tnm_instances.sh
./run_converters.sh
./run_concorde.sh
./run_lkh.sh
./run_gpuACS.sh
./run_pihc.sh
./delete_concorde_solutions.sh
./delete_gpuACS_solutions.sh
./delete_pihc_solutions.sh
./delete_lkh_solutions.sh
./delete_tnm_instances.sh
./delete_dimacs_instances.sh


