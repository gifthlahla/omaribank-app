import os
import re

package_name = 'omari_bank_app'

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            def replace_import(match):
                imp = match.group(1)
                if imp.startswith('.') and imp.endswith('.dart'):
                    lib_dir = os.path.abspath('lib')
                    current_dir = os.path.abspath(root)
                    target_path = os.path.normpath(os.path.join(current_dir, imp))
                    
                    if target_path.startswith(lib_dir):
                        rel_to_lib = os.path.relpath(target_path, lib_dir).replace('\\\\', '/')
                        return f"import 'package:{package_name}/{rel_to_lib}';"
                return match.group(0)

            new_content = re.sub(r"import '([^']+)';", replace_import, content)
            
            if new_content != content:
                print(f"Fixed {filepath}")
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
