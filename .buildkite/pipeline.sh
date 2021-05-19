#!/usr/bin/env bash

      set -euo pipefail
      file="helloworld.log"
      if [[ -f "${file}" ]]; then

        sizeofplan="$(stat -c%s "${file}")"

        echo "tf_plan_changes is ${sizeofplan} bytes in size using GNU option "

        sizeofplan="$(stat -f%s "${file}")"

        echo "tf_plan_changes is ${sizeofplan} bytes in size using BSD option "

        sizeofplan="$(wc -c < "${file}")"

        echo "tf_plan_changes is ${sizeofplan} bytes in size using cat pipe wc option "



        echo -e "Changes planned for " > "blah/annotation"           
        echo '<pre class="term"><code>' >> "blah/annotation"

        if [[ "$sizeofplan" -gt 1000000 ]]; then
          cat ${file} | grep -E '(^.*[#~+-] .*|^[[:punct:]]|Plan)' | terminal-to-html >> "blah/annotation"        
        else
          cat ${file} | terminal-to-html >> "blah/annotation"
        fi

        echo '</code></pre>' >> "blah/annotation"
        cat "blah/annotation" | buildkite-agent annotate --style "warning" --context "blah" || \
        echo -e "blah\n\nFAILED TO PRINT ANNOTATION - PLEASE CHECK THE BUILD OUTPUT FOR IT" buildkite-agent annotate --style "warning" --context "blah"
      else
        echo "there is no file"
      fi
