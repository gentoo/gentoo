# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="Set of modules that provide a simple manipulation of XML streams"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591aeb88c7a4473fcbb154f8 ->
	${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018 +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	^^ ( gnat_2016 gnat_2017 gnat_2018 )"

RDEPEND="gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )
	gnat_2018? ( dev-lang/gnat-gpl:7.3.1 )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?]"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure () {
	econf --prefix="${D}"/usr
}

src_compile () {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XBUILD=Production -XPROCESSORS=$(makeopts_jobs) xmlada.gpr \
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
	emake run_test | grep DIFF && die
}

src_install () {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -XBUILD=Production \
			-XPROCESSORS=$(makeopts_jobs) --prefix="${D}"usr \
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
	rm "${D}"/usr/share/doc/${PN}/.buildinfo || die
	rm -r "${D}"/usr/share/gpr/manifests || die
}
