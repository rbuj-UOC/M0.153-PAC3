#!/usr/bin/env bash

# Other possible shebangs:
##!/bin/bash
##!/opt/homebrew/bin/bash
##!/usr/local/bin/bash

# parse command line options
GENERATE_PDF=true
GENERATE_HTML=true
FILENAME="resposta"
while getopts "h-:" opt; do
    case "$opt" in
        -)
            case "${OPTARG}" in
                pdf)
                    GENERATE_HTML=false
                    ;;
                html)
                    GENERATE_PDF=false
                    ;;
                help)
                    echo "Usage: $0 [--pdf] [--html]"
                    echo "  --pdf    Generate only PDF report"
                    echo "  --html   Generate only HTML report"
                    exit 0
                    ;;
                *)
                    echo "Invalid option: --${OPTARG}"
                    exit 1
                    ;;
            esac
            ;;
        h)
            echo "Usage: $0 [--pdf] [--html]"
            echo "  --pdf    Generate only PDF report"
            echo "  --html   Generate only HTML report"
            exit 0
            ;;
        *)
            echo "Invalid option: -${opt}"
            exit 1
            ;;
    esac
done

# clean up previous reports
rm -fr ${FILENAME}_* ${FILENAME}.html ${FILENAME}.pdf

if [ "$GENERATE_HTML" = true ]; then
    echo "Generating HTML report..."
    Rscript -e "rmarkdown::render('$FILENAME.Rmd', output_format = 'html_document')"
fi

if [ "$GENERATE_PDF" = true ]; then
    echo "Generating PDF report..."
    # Rscript -e "rmarkdown::render('$FILENAME.Rmd', output_format = 'pdf_document', clean = TRUE)" --shell-escape
    Rscript -e "rmarkdown::render('$FILENAME.Rmd', output_format = 'pdf_document')"
fi