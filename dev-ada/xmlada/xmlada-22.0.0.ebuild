# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2019 gnat_202{0..1} )
inherit ada multiprocessing

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-2019-gentoo.patch )

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}

src_test() {
	emake test
	emake run_test | tee xmlada.testLog
	grep -q DIFF xmlada.testLog && die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -XBUILD=Production \
			-XPROCESSORS=$(makeopts_jobs) --prefix="${D}"/usr \
			--install-name=xmlada --build-var=LIBRARY_TYPE \
			--build-var=XMLADA_BUILD \
			--build-name=$1 xmlada.gpr || die "gprinstall failed"
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi

	einstalldocs
	dodoc xmlada-roadmap.txt
	rm -rf "${D}"/usr/share/gpr/manifests
	mv "${D}"/usr/share/examples/xmlada "${D}"/usr/share/doc/"${PF}"/examples || die
}
