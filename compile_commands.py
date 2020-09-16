import os
import json
import argparse

try:
    cc = os.environ['CC']
except:
    cc = 'cc'

parser = argparse.ArgumentParser(description='')
parser.add_argument('sources', metavar='list of sources', type=str, nargs='+',
                    help='list of sources to generate compile_commands for')

parser.add_argument('--builddir', dest='bdir', default=os.getcwd())
parser.add_argument('--sourcedir', dest='sdir', default=os.getcwd())
parser.add_argument('--includedir', dest='idir', default=os.getcwd())
parser.add_argument('--odir', dest='odir', default=os.getcwd())

parser.add_argument('--compiler', dest='cc', default=cc)
parser.add_argument('--cflags', dest='cflags', default='')
parser.add_argument('--libs', dest='libs', default='')

args = parser.parse_args()
args.sources = [os.path.join(args.sdir, s) for s in args.sources]
objs = [s.replace(".c", ".o").replace(args.sdir, os.path.abspath(args.odir)) for s in args.sources]
targets = []
for src, obj in zip(args.sources, objs):
    targets.append({
        "directory": os.path.abspath(args.bdir),
        "command": "{}{}{} -I{} -c {} -o {}"
                   .format(args.cc, args.cflags, args.libs, args.idir, os.path.abspath(src), obj),
        "file": os.path.abspath(src)
    });

with open(os.path.join(args.bdir, "compile_commands.json"), "w") as f:
    print(json.dumps(targets, indent=4), file=f)
