# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="A pure-python graphics and GUI library built on PyQt and numpy"
HOMEPAGE="
	https://www.pyqtgraph.org/
	https://github.com/pyqtgraph/pyqtgraph/
	https://pypi.org/project/pyqtgraph/
"
SRC_URI="
	https://github.com/pyqtgraph/pyqtgraph/archive/${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv ~x86"
IUSE="opengl svg qt5 +qt6"
REQUIRED_USE="test? ( opengl svg ) || ( qt5 qt6 )"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
	qt5? ( dev-python/pyqt5[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}] )
	qt6? ( dev-python/pyqt6[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
		qt5? ( dev-python/pyqt5[testlib,${PYTHON_USEDEP}] )
		qt6? ( dev-python/pyqt6[testlib,${PYTHON_USEDEP}] )
		dev-vcs/git
	)
	sys-apps/gawk
"

EPYTEST_PLUGINS=( pytest-xvfb )
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# apparently fragile
	tests/test_reload.py::test_reload

	# TODO
	tests/exporters/test_svg.py::test_plotscene
	tests/graphicsItems/test_ROI.py::test_PolyLineROI
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi

	# pyqtgraph will automatically use any QT bindings it finds,
	# patch the supported Qt versions to only include the ones we have enabled
	# This can be simplified to:
	# `sed 's/QT_LIB = os.getenv('PYQTGRAPH_QT_LIB')/'QT_LIB = "PyQt6"/' -i pyqtgraph/Qt/__init__.py`
	# when we only need to support pyqt6.
	local upstream_supported_qt=(
		PySide{,2,6}
		PyQt{4,5,6}
	)
	local gentoo_qt=()
	local is_supported_impl use_qt qt
	# pyqtgraph has conditionals that depend on these values; we can't just remove them.
	# set deselected or unsupported to None to avoid more patching
	for qt in "${upstream_supported_qt[@]}"; do
		is_supported_impl=0
		case ${qt} in
			PyQt5) is_supported_impl=1; use_qt=${qt:2} ;;
			PyQt6) is_supported_impl=1; use_qt=${qt:2} ;;
		esac
		if [[ "${is_supported_impl}" -eq 0 ]]; then
			gentoo_qt+=( "${qt^^} = None" )
			continue
		fi
		if use ${use_qt,,}; then
			gentoo_qt+=( "${qt^^} = '${qt}'" )
		else
			gentoo_qt+=( "${qt^^} = None" )
		fi
	done

	gawk -v qt_string="$(printf "%s\n" "${gentoo_qt[@]}")" -i inplace '
	BEGIN {
		i = 0
		split(qt_string, qt_array, "\n")
		j = 1
	}
	/PYSIDE = '"'"'PySide'"'"'/ {
		i = 6 # length of upstream_supported_qt
		for (k = 1; k <= length(qt_array); k++) {
		print qt_array[k]
		j++
		}
	}
	i > 0 {
		i--
		next
	}
	{ print }
	' pyqtgraph/Qt/__init__.py || die "Failed to patch supported Qt versions"

	# We also need to remove them from load order.
	local liborder=()
	local qt
	# The order is important (we want to prefer the newest at runtime)
	for qt in qt6 qt5; do
		if use ${qt}; then
			liborder+=( "PY${qt^^}" )
		fi
	done

	gawk -v libOrder="$(printf "%s, " "${liborder[@]}")" -i inplace '
	BEGIN {
		libOrder = "[" substr(libOrder, 1, length(libOrder) - 2) "]"
	}
	/libOrder = \[PYQT6, PYSIDE6, PYQT5, PYSIDE2\]/ {
		sub(/\[PYQT6, PYSIDE6, PYQT5, PYSIDE2\]/, libOrder)
	}
	{ print }
	' pyqtgraph/Qt/__init__.py || die "Failed to patch qt version order"

	# Finally update the list of supported frontends in test to never try unsupported or deselected
	if use test; then
		local frontends=()
		for qt in qt5 qt6; do
			if use ${qt}; then
				frontends+=( "Qt.PY${qt^^}: False," )
			fi
		done
		gawk -v frontends="$(printf "%s\n" "${frontends[@]}")" -i inplace '
		BEGIN {
			i = 0
			split(frontends, frontend_array, "\n")
			j = 1
		}
		/frontends = {/ {
			i = 6 # length of frontends

		print "frontends = {"
		for (k = 1; k <= length(frontend_array); k++) {
			print "    " frontend_array[k]
		}
		print "}"
		}
		i > 0 {
			i--
			next
		}
		{ print }
		' pyqtgraph/examples/test_examples.py || die "Failed to patch test frontends"
	fi
}
