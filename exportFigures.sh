#!/usr/bin/env sh

# settings
base=$(pwd)
dataDir="$base/data"
figureDir="$base/figures"
outputDir="$base/svg"
cfg="$base/config.tex"

# prepare env
mkdir $outputDir 2> /dev/null

# process all files
for fin in $figureDir/*.tex; do
	name=$(basename $fin .tex)
	fout="$outputDir/$name.svg"
	echo $name

	# prepare working dir
	tmp=$(mktemp -d)
	cd $tmp
	ln -s $dataDir data

	# generate source code
	cat > figure.tex <<EOF
\\documentclass{standalone}
\\input{$cfg}
\\begin{document}
\\input{$fin}
\\end{document}
EOF

	# compile and convert
	pdflatex figure.tex > /dev/null
	inkscape -l $fout figure.pdf

	# clean up
	cd $base
	rm -rf $tmp
done


