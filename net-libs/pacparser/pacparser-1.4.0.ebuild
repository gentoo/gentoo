# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10,11} )

inherit python-r1 toolchain-funcs

DESCRIPTION="Library to parse proxy auto-config files"
HOMEPAGE="http://pacparser.manugarg.com/"
SRC_URI="https://github.com/manugarg/${PN}/archive/v${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc python"

DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# spidermonkey-1.7.0 is bundled
# tested unbundling with spidermonkey-1.8* and 1.7
# and got many failures: unbundling not worth it.

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-pymod.patch"
)

src_prepare() {
	default

	sed -e '/CC = gcc/d' \
		-i src/spidermonkey/js/src/config/Linux_All.mk || die

	export NO_INTERNET=yes
	export VERSION="${PV}"
	tc-export CC AR RANLIB
}

src_compile() {
	# Upstream parallel compilation bug, do that first to work around
	emake -C src/spidermonkey
	emake -C src
	use python && python_foreach_impl emake -C src pymod
}

src_install() {
	emake \
		LIB_PREFIX="${ED}/usr/$(get_libdir)" \
		DOC_PREFIX="${ED}/usr/share/doc/${PF}" \
		BIN_PREFIX="${ED}"/usr/bin \
		INC_PREFIX="${ED}"/usr/include \
		MAN_PREFIX="${ED}"/usr/share/man \
		-C src install
	dodoc README.md

	if use python; then
		python_foreach_impl emake DESTDIR="${D}" -C src install-pymod
		python_foreach_impl python_optimize
	fi

	if use doc; then
		docompress -x /usr/share/doc/${PF}/{html,examples}
	else
		rm -r "${ED}"/usr/share/doc/${PF}/{html,examples} || die
	fi
}
