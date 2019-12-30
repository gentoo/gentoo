# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="HFS FS Access utils"
HOMEPAGE="https://www.mars.org/home/rob/proj/hfs/"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="tcl tk"

DEPEND="
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )
"
RDEPEND="
	${DEPEND}
"

# use tk requires tcl - bug #150437
REQUIRED_USE="tk? ( tcl )"
PATCHES=(
	"${FILESDIR}"/largerthan2gb.patch
	"${FILESDIR}"/${P/_p*}-fix-tcl-8.6.patch
)
S=${WORKDIR}/${P/_p*}

src_prepare() {
	eapply $(
		for file in $(cat "${WORKDIR}"/debian/patches/series)
			do echo "${WORKDIR}"/debian/patches/${file}
		done
	)
	default
}

src_configure() {
	tc-export CC
	econf $(use_with tcl) $(use_with tk)
}

src_compile() {
	emake AR="$(tc-getAR) rc" CC="$(tc-getCC)" RANLIB="$(tc-getRANLIB)"
	emake CC="$(tc-getCC)" -C hfsck
}

src_install() {
	dodir /usr/bin /usr/lib /usr/share/man/man1
	emake \
		prefix="${ED}"/usr \
		MANDEST="${ED}"/usr/share/man \
		infodir="${ED}"/usr/share/info \
		install
	dobin hfsck/hfsck
	dodoc BLURB CHANGES README TODO doc/*.txt
}
