# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs udev

DESCRIPTION="IrDA management and handling utilities"
HOMEPAGE="http://irda.sourceforge.net"
SRC_URI="mirror://sourceforge/irda/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~sh x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=sys-apps/pciutils-2.2.7-r1
	sys-process/procps
	sys-apps/setserial
	sys-apps/grep
	virtual/udev
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	!app-laptop/smcinit
"

PATCHES=(
	"${FILESDIR}/${PN}-rh1.patch"
	"${FILESDIR}/${P}-makefile.diff"
	"${FILESDIR}/${P}-smcinit.diff"
	"${FILESDIR}/${P}-io.h.diff"
	"${FILESDIR}/${P}-dofail.patch"
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-headers.patch"
	"${FILESDIR}/${P}-SIOCGSTAMP.patch"
)

src_prepare() {
	# TODO: switch to 'default' once udev.eclass is EAPI=6 clean
	epatch -p1 "${PATCHES[@]}"

	append-flags "-fno-strict-aliasing" # bug????

	# fix Bug 570488 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	# fix crosscompile, respect CFLAGS (Bug 200295)
	sed -i -e "/^CC/s:gcc:$(tc-getCC):" \
		-e "/^LD/s:ld:$(tc-getLD):" \
		-e "/^AR/s:ar:$(tc-getAR):" \
		-e "/^RANLIB/s:ranlib:$(tc-getRANLIB):" \
		-e "/^CFLAGS/s:-O2:${CFLAGS}:" Makefile */Makefile || die

	# fix compile when pciutils is compiled with USE=zlib (Bug 200295)
	sed -i -e "s:-lpci:$(pkg-config --libs libpci):g" smcinit/Makefile || die

	# disable etc subdir in Makefile
	sed -i -e "s:^\(DIRS.*=.* \)etc \(.*\):\1\2:g" Makefile || die

	# disable write_pid(), because we don't need it
	sed -i -e "s:\(write_pid();\):/* \1 */:g" irattach/util.c || die
}

src_compile() {
	emake RPM_OPT_FLAGS="${CFLAGS}" RPM_BUILD_ROOT="${D}" ROOT="${D}"
}

src_install () {
	dodir /usr/bin
	dodir /usr/sbin

	emake install RPM_OPT_FLAGS="${CFLAGS}" ROOT="${D}" \
		MANDIR="${D}usr/share/man"

	newdoc ethereal/README     README.wireshark
	newdoc irattach/README     README.irattach
	newdoc irdadump/README     README.irdadump
	newdoc irdaping/README     README.irdaping
	newdoc irsockets/README    README.irsockets
	newdoc tekram/README       README.tekram
	newdoc smcinit/README      README.smcinit
	newdoc smcinit/README.Peri README.smcinit.Peri
	newdoc smcinit/README.Rob  README.smcinit.Rob
	newdoc smcinit/README.Tom  README.smcinit.Tom
	newdoc irattach/ChangeLog  ChangeLog.irattach
	newdoc irdadump/ChangeLog  ChangeLog.irdadump
	newdoc smcinit/ChangeLog   ChangeLog.smcinit
	dohtml smcinit/RobMiller-irda.html
	dodoc README

	newconfd "${FILESDIR}/irda.confd" irda
	newinitd "${FILESDIR}/irda.initd" irda

	insinto /etc/modprobe.d
	newins "${FILESDIR}/irda.modsd" irda.conf

	udev_newrules "${FILESDIR}/irda.rules" 53-irda.rules
	exeinto "$(get_udevdir)"
	newexe "${FILESDIR}/irda-setup.sh" irda-setup
	newexe "${FILESDIR}/irda-usb.sh" irda-usb
}
