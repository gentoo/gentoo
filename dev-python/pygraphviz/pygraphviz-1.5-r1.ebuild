# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="http://pygraphviz.github.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ppc x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
RDEPEND="media-gfx/graphviz"
BDEPEND="${RDEPEND}
	dev-lang/swig:0
	test? (
		dev-python/doctest-ignore-unicode[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
    dev-python/wheel[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${P}-docs.patch" )

distutils_enable_sphinx doc

distutils_enable_tests setup.py

python_prepare_all() {

  sed --in-place \
    --expression='s/recursive-include examples .*//g' \
    --expression='s/recursive-include doc .*//g' MANIFEST.in || die

  # fix graphviz swig interface - see https://github.com/pygraphviz/pygraphviz/issues/174
  rm pygraphviz/graphviz.py pygraphviz/graphviz_wrap.c

  cat > pygraphviz/graphviz.i <<- EOF
	%module graphviz

  %{
  #include "/usr/include/graphviz/cgraph.h"
  %}

  %include "/usr/include/graphviz/cgraph.h"

  %exception agnode {
    $action
    if (!result) {
       PyErr_SetString(PyExc_KeyError,"agnode: no key");
       return NULL;
    }
  }

  %exception agedge {
    $action
    if (!result) {
       PyErr_SetString(PyExc_KeyError,"agedge: no key");
       return NULL;
    }
  }

  /* agset returns -1 on error */
  %exception agset {
    $action
    if (result==-1) {
       PyErr_SetString(PyExc_KeyError,"agset: no key");
       return NULL;
    }
  }

  /* agsetsafeset_label returns -1 on error */
  %exception agsafeset_label {
    $action
    if (result==-1) {
       PyErr_SetString(PyExc_KeyError,"agsafeset_label: Error");
       return NULL;
    }
  }


  /* agdelnode returns -1 on error */
  %exception agdelnode {
    $action
    if (result==-1) {
       PyErr_SetString(PyExc_KeyError,"agdelnode: no key");
       return NULL;
    }
  }

  %exception agnxtattr {
    $action
    if (!result) {
       PyErr_SetString(PyExc_StopIteration,"agnxtattr");
       return NULL;
    }
  }

  %exception agattr {
    $action
    if (!result) {
       PyErr_SetString(PyExc_KeyError,"agattr: no key");
       return NULL;
    }
  }


  %exception agattr_label {
    $action
    if (!result) {
       PyErr_SetString(PyExc_KeyError,"agattr_label: no key");
       return NULL;
    }
  }

  %exception agread {
    $action
    if (!result) {
       PyErr_SetString(PyExc_ValueError,"agread: bad input data");
       return NULL;
    }
  }

  %pythoncode %{
  def agraphnew(name,strict=False,directed=False):
      if strict:
         if directed:
              return _graphviz.agopen(name,cvar.Agstrictdirected,None)
         else:
              return _graphviz.agopen(name,cvar.Agstrictundirected,None)
      else:
          if directed:
              return _graphviz.agopen(name,cvar.Agdirected,None)
          else:
              return _graphviz.agopen(name,cvar.Agundirected,None)
  %}

  %pythoncode %{
  def agnameof(handle):
    name=_graphviz.agnameof(handle)
    if name is None:
       return None
    if name==b'' or name.startswith(b'%'):
      return None
    else:
      return name
  %}
	EOF

#  sed --in-place \
#    --expression='s/int agattr_label(Agraph_t/Agsym_t * agattr_label(Agraph_t/g' \
#    --expression='s/unsigned long id, int createflag/IDTYPE id, int createflag/g' \
#    pygraphviz/graphviz.i || die
#
	swig -python -py3 -builtin -fastproxy -extranative -castmode pygraphviz/graphviz.i || die

	distutils-r1_python_prepare_all
}

#python_test() {
#	PYTHONPATH=${PYTHONPATH}:${BUILD_DIR}/lib/pygraphviz \
#		nosetests -c setup.cfg -x -v || die
#}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
