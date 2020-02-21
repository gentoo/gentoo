# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib systemd toolchain-funcs user xdg

DESCRIPTION="The X2Go server"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fuse postgres +sqlite"

REQUIRED_USE="|| ( postgres sqlite )"

DEPEND="virtual/perl-ExtUtils-MakeMaker"
RDEPEND="dev-lang/perl:=
	dev-perl/Capture-Tiny
	dev-perl/Config-Simple
	dev-perl/File-BaseDir
	dev-perl/File-ReadBackwards
	dev-perl/File-Which
	dev-perl/Switch
	dev-perl/Try-Tiny
	media-fonts/font-cursor-misc
	media-fonts/font-misc-misc[nls]
	>=net-misc/nx-3.5.99.14
	net-misc/openssh
	>=sys-apps/iproute2-4.3.0
	x11-apps/xauth
	x11-apps/xhost
	x11-apps/xwininfo
	fuse? ( net-fs/sshfs )
	postgres? ( dev-perl/DBD-Pg )
	sqlite? ( dev-perl/DBD-SQLite )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.0.0-Xresources.patch
	"${FILESDIR}"/${PN}-4.1.0.0-skip_man2html.patch
	)

pkg_setup() {
	# Force the group creation, #479650
	enewgroup x2gouser
	enewgroup x2goprint
	enewuser x2gouser -1 -1 /var/lib/x2go x2gouser
	enewuser x2goprint -1 -1 /var/spool/x2goprint x2goprint
}

src_prepare() {
	default
	# Multilib clean
	sed -e "s#/lib/#/$(get_libdir)/#" -i x2goserver/bin/x2gopath || die

	# Do not compress man pages by default
	sed '/^[[:space:]]*gzip.*man/d' -i */Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LIBDIR="/usr/$(get_libdir)/x2go" \
		PREFIX=/usr
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIBDIR="/usr/$(get_libdir)/x2go" \
		NXLIBDIR="/usr/$(get_libdir)/nx" \
		PREFIX=/usr \
		install

	fowners root:x2goprint /usr/bin/x2goprint
	fperms 2755 /usr/bin/x2goprint
	fperms 0750 /etc/sudoers.d
	fperms 0440 /etc/sudoers.d/x2goserver
	dosym ../../usr/share/applications /etc/x2go/applications

	newinitd "${FILESDIR}"/${PN}.init x2gocleansessions
	systemd_dounit "${FILESDIR}"/x2gocleansessions.service
}

pkg_postinst() {
	xdg_pkg_postinst
	if use sqlite ; then
		if [[ -f "${EROOT}"/var/lib/x2go/x2go_sessions ]] ; then
			elog "To use sqlite and update your existing database, run:"
			elog " # x2godbadmin --updatedb"
		else
			elog "To use sqlite and create the initial database, run:"
			elog " # x2godbadmin --createdb"
		fi

	fi
	if use postgres ; then
		elog "To use a PostgreSQL database, more information is availabe here:"
		elog "http://www.x2go.org/doku.php/wiki:advanced:multi-node:x2goserver-pgsql"
	fi

	elog "For password authentication, you need to enable PasswordAuthentication"
	elog "in /etc/ssh/sshd_config (disabled by default in Gentoo)"
	elog "An init script was installed for x2gocleansessions"
}
