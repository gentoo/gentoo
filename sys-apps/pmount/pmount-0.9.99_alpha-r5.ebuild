# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1

DESCRIPTION="Policy based mounter that gives the ability to mount removable devices as a user"
HOMEPAGE="https://launchpad.net/pmount"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV/_/-}.orig.tar.bz2"
S=${WORKDIR}/${P/_/-}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE="crypt"

RDEPEND="
	acct-group/plugdev
	>=sys-apps/util-linux-2.17.2
	crypt? ( >=sys-fs/cryptsetup-1.0.6-r2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.19-testsuite-missing-dir.patch
	"${FILESDIR}"/${P}-locale-regex.patch
)

src_prepare() {
	# Restore default value from pmount <= 0.9.23 wrt #393633
	sed -i -e '/^not_physically_logged_allow/s:=.*:= yes:' etc/pmount.conf || die

	cat <<-EOF > po/POTFILES.skip || die
	src/conffile.c
	src/configuration.c
	src/loop.c
	EOF

	default
}

src_configure() {
	econf --disable-hal
}

src_test() {
	local testdir=${S}/tests/check_fstab

	ln -s a "${testdir}/b" &&
		ln -s d "${testdir}/c" &&
		ln -s c "${testdir}/e" ||
		die "Unable to create fake symlinks required for testsuite"

	emake check
}

src_install() {
	# Must be run SETUID+SETGID, bug #250106
	exeinto /usr/bin
	exeopts -m 6710 -g plugdev
	doexe src/{p,pu}mount

	dodoc AUTHORS ChangeLog TODO
	doman man/{{p,pu}mount.1,pmount.conf.5}

	insinto /etc
	doins etc/pmount.{allow,conf}

	keepdir /media #501772

	newbashcomp "${FILESDIR}/${PN}.bash-completion" "${PN}"
	bashcomp_alias pmount pumount
}

pkg_postinst() {
	elog
	elog "This package has been installed setuid and setgid."

	elog "The permissions are as such that only users that belong to the plugdev"
	elog "group are allowed to run this. But if a script run by root mounts a"
	elog "device, members of the plugdev group will have access to it."
	elog
	elog "Please add your user to the plugdev group to be able to mount USB drives"
}
