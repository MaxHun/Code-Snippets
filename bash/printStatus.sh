#!/bin/bash
squeue -o "%.10a %.10i %.9P %.70j %.8u %.8T %.10M %.9l %.6D %R %p" | grep -a 'gpu'
