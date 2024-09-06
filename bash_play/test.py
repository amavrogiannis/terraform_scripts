import os
import sys
import argparse

def main():
    # output_this = str(sys.argv[1])

    # print(output_this)

    parser=argparse.ArgumentParser()
    parser.add_argument("--env", choices=['this', 'that', 'none'])
    args=parser.parse_args()
    print (args.env)

main()