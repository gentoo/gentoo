# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="https://github.com/pydata/numexpr"
SRC_URI="https://github.com/pydata/numexpr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="mkl"

DEPEND="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
	mkl? ( sci-libs/mkl )
"
RDEPEND=${DEPEND}
BDEPEND="
	mkl? ( virtual/pkgconfig )
"

python_prepare_all() {
	# TODO: mkl can be used but it fails for me
	# only works with mkl in tree. newer mkl will use pkgconfig
	if use mkl; then
		local suffix=
		use amd64 && local suffix="-lp64"

		local flags=(
			$($(tc-getPKG_CONFIG) --cflags --libs "mkl-dynamic${suffix}-iomp")
		)
		local f libdirs=() incdirs=() libs=()
		for f in "${flags[@]}"; do
			case ${f} in
				-I*)
					incdirs+=( "${f#-I}" )
					;;
				-L*)
					libdirs+=( "${f#-L}" )
					;;
				-l*)
					libs+=( "${f#-l}" )
					;;
				*)
					die "Unexpected flag in pkg-config output: ${f}"
					;;
			esac
		done

		cat > site.cfg <<- _EOF_ || die
			[mkl]
			library_dirs = $(IFS=:; echo "${libdirs[*]}")
			include_dirs = $(IFS=:; echo "${incdirs[*]}")
			libraries = $(IFS=:; echo "${libs[*]}")
		_EOF_
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	"${EPYTHON}" \
		-c "import sys,numexpr; sys.exit(0 if numexpr.test().wasSuccessful() else 1)" \
		|| die
	pushd >/dev/null || die
}
