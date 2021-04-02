# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils fixheadtails toolchain-funcs

DEBIAN_PV="10"
MY_P="${P/-/_}"
DEBIAN_URI="mirror://debian/pool/main/${PN:0:1}/${PN}"
DEBIAN_PATCH="${MY_P}-${DEBIAN_PV}.debian.tar.xz"
DEBIAN_SRC="${MY_P}.orig.tar.gz"
DESCRIPTION="display or set the kernel time variables"
HOMEPAGE="https://www.ibiblio.org/pub/Linux/system/admin/time/adjtimex.lsm https://github.com/rogers0/adjtimex"
SRC_URI="${DEBIAN_URI}/${DEBIAN_PATCH}
	${DEBIAN_URI}/${DEBIAN_SRC}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE=""

DEPEND="sys-apps/sed"

src_unpack() {
	unpack "${DEBIAN_SRC}"
	cd "${S}" || die "Failed to cd ${S}"
	unpack "${DEBIAN_PATCH}"
}

src_prepare() {
	# Debian series first
	DEBPATCHDIR="${S}"/debian/patches/
	for f in $(cat "$DEBPATCHDIR/series") ; do
		eapply "$DEBPATCHDIR"/$f
	done
	# Then gentoo changes
	for i in debian/adjtimexconfig debian/adjtimexconfig.8 ; do
		sed -e 's|/etc/default/adjtimex|/etc/conf.d/adjtimex|' \
			-i.orig ${i}
		sed -e 's|^/sbin/adjtimex |/usr/sbin/adjtimex |' \
			-i.orig ${i}
	done
	eapply "${FILESDIR}"/${PN}-1.29-r2-gentoo-utc.patch
	ht_fix_file debian/adjtimexconfig
	sed -i \
		-e '/CFLAGS = -Wall -t/,/endif/d' \
		-e '/$(CC).* -o/s|$(CFLAGS)|& $(LDFLAGS)|g' \
		Makefile.in || die "sed Makefile.in"
	eapply_user
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	dodoc README* ChangeLog
	doman adjtimex.8 debian/adjtimexconfig.8
	dosbin adjtimex debian/adjtimexconfig
	newinitd "${FILESDIR}"/adjtimex.init adjtimex
}

pkg_postinst() {
	einfo "Please run adjtimexconfig to create the configuration file"
}
