# This file is NOT licensed under the GPLv3, which is the license for the rest
# of YouCompleteMe.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

from distutils.sysconfig import get_python_inc
import platform
import os
import subprocess

DIR_OF_THIS_SCRIPT = os.path.abspath(os.path.dirname(__file__))
SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    '-fexceptions',
    '-DNDEBUG',
    # THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
    # use when compiling headers. So it will guess. Badly. So C++ headers will be
    # compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
    # For a C project, you would set this to 'c' instead of 'c++'.
    '-x',
    'c++',
    '-isystem',
    get_python_inc(),
]

# Clang automatically sets the '-std=' flag to 'c++14' for MSVC 2015 or later,
# which is required for compiling the standard library, and to 'c++11' for older
# versions.
if platform.system() != 'Windows':
    flags.append('-std=c++17')

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']

def FindCorrespondingSourceFile(filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                return replacement_file
    return filename

def Settings(**kwargs):
    if kwargs['language'] == 'cfamily':
        # If the file is a header, try to find the corresponding source file and
        # retrieve its flags from the compilation database if using one. This is
        # necessary since compilation databases don't have entries for header files.
        # In addition, use this source file as the translation unit. This makes it
        # possible to jump from a declaration in the header file to its definition
        # in the corresponding source file.
        filename = FindCorrespondingSourceFile(kwargs['filename'])

        return {
            'flags': flags,
            'include_paths_relative_to_dir': DIR_OF_THIS_SCRIPT,
            'override_filename': filename
        }

