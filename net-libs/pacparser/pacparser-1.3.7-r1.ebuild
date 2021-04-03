# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8} )

inherit python-r1 toolchain-funcs

DESCRIPTION="Library to parse proxy auto-config files"
HOMEPAGE="http://pacparser.manugarg.com/"
SRC_URI="https://github.com/pacparser/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc python"

DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# spidermonkey-1.7.0 is bundled
# tested unbundling with spidermonkey-1.8* and 1.7
# and got many failures: unbundling not worth it.

src_prepare() {
	default
	sed -e 's|CFLAGS = |CFLAGS := $(CFLAGS) |' \
		-e 's|= $(PREFIX)|:=  $(PREFIX)|g' \
		-e "s|share/doc.*pacparser|share/doc/${PF}|g" \
		-e "s|/lib|/$(get_libdir)|g" \
		-i src/Makefile || die
	export NO_INTERNET=yes
	tc-export CC AR RANLIB
}

src_compile() {
	emake -C src spidermonkey/js/src
	sed -e '/CC = gcc/d' \
		-i src/spidermonkey/js/src/config/Linux_All.mk || die
	# Upstream parallel compilation bug, do that first to work around
	emake -C src/spidermonkey
	emake -C src
	use python && python_foreach_impl emake -C src pymod
}

src_test() {
	emake -C src testpactester
}

src_install() {
	emake DESTDIR="${ED}" LIB_PREFIX="${ED}/usr/$(get_libdir)" -C src install
	dodoc README.md

	if use python; then
		python_foreach_impl emake DESTDIR="${D}" \
			LIB_PREFIX="${D}/usr/$(get_libdir)" -C src install-pymod
		python_foreach_impl python_optimize
	fi

	if use doc; then
		docompress -x /usr/share/doc/${PF}/{html,examples}
	else
		rm -r "${ED}"/usr/share/doc/${PF}/{html,examples} || die
	fi
}
