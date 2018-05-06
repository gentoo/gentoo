# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib systemd toolchain-funcs user xdg-utils

DESCRIPTION="The X2Go server"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fuse postgres +sqlite"

REQUIRED_USE="|| ( postgres sqlite )"

DEPEND=""
RDEPEND="dev-perl/Capture-Tiny
	dev-perl/Config-Simple
	dev-perl/File-BaseDir
	dev-perl/File-ReadBackwards
	dev-perl/File-Which
	dev-perl/Try-Tiny
	media-fonts/font-cursor-misc
	media-fonts/font-misc-misc[nls]
	>=net-misc/nx-3.5.0.25
	net-misc/openssh
	>=sys-apps/iproute2-4.3.0
	x11-apps/xauth
	x11-apps/xhost
	x11-apps/xwininfo
	fuse? ( net-fs/sshfs )
	postgres? ( dev-perl/DBD-Pg )
	sqlite? ( dev-perl/DBD-SQLite )"

PATCHES=(
	)

pkg_setup() {
	# Force the group creation, #479650
	enewgroup x2gouser
	enewgroup x2goprint
	enewuser x2gouser -1 -1 /var/lib/x2go x2gouser
	enewuser x2goprint -1 -1 /var/spool/x2goprint x2goprint
}

src_prepare() {
	# Do not install Xresources symlink (#521126)
	sed -e '\#$(INSTALL_SYMLINK) /etc/X11/Xresources# s/^/#/' -i x2goserver-xsession/Makefile || die
	# Multilib clean
	sed -e "/^LIBDIR=/s/lib/$(get_libdir)/" -i Makefile */Makefile || die
	sed -e "s#/lib/#/$(get_libdir)/#" -i x2goserver/bin/x2gopath || die
	# Skip man2html build
	sed -e "s/build-indep: build_man2html/build-indep:/" -i Makefile */Makefile || die
	# Use nxagent directly
	sed -i -e "/NX_TEMP=/s/x2goagent/nxagent/" x2goserver/bin/x2gostartagent || die

	default
}

src_compile() {
	emake CC="$(tc-getCC)" PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	fowners root:x2goprint /usr/bin/x2goprint
	fperms 2755 /usr/bin/x2goprint
	fperms 0750 /etc/sudoers.d
	fperms 0440 /etc/sudoers.d/x2goserver
	dosym ../../usr/share/applications /etc/x2go/applications

	newinitd "${FILESDIR}"/${PN}.init x2gocleansessions
	systemd_dounit "${FILESDIR}"/x2gocleansessions.service
}

pkg_postinst() {
	if use sqlite ; then
		elog "To use sqlite and create the initial database, run:"
		elog " # x2godbadmin --createdb"
	fi
	if use postgres ; then
		elog "To use a PostgreSQL database, more information is availabe here:"
		elog "http://www.x2go.org/doku.php/wiki:advanced:multi-node:x2goserver-pgsql"
	fi

	elog "For password authentication, you need to enable PasswordAuthentication"
	elog "in /etc/ssh/sshd_config (disabled by default in Gentoo)"
	elog "An init script was installed for x2gocleansessions"

	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
