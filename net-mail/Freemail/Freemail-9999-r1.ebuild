# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

EGIT_REPO_URI="git://github.com/freenet/plugin-Freemail-official.git
	https://github.com/freenet/plugin-Freemail-official.git"
EGIT_PROJECT="Freemail/official"
EANT_BUILD_TARGET="dist"
inherit eutils git-2 java-pkg-2 java-ant-2

DESCRIPTION="Anonymous IMAP/SMTP e-mail server over Freenet"
HOMEPAGE="http://www.freenetproject.org/tools.html"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="dev-java/bcprov:1.38
	net-p2p/freenet"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

EANT_GENTOO_CLASSPATH="bcprov freenet"

src_prepare() {
	epatch "${FILESDIR}"/build.patch
	java-ant_rewrite-classpath
}

src_install() {
	java-pkg_dojar dist/"${PN}.jar"
	dodir /var/freenet/plugins
	fperms freenet:freenet /var/freenet/plugins
	dodoc README || die "installation of documentation failed"
}

pkg_postinst () {
	#force chmod for previously existing plugins dir owned by root
	[[ $(stat --format="%U" /var/freenet/plugins) == "freenet" ]] || chown \
		freenet:freenet /var/freenet/plugins
	elog "To load Freemail, go to the plugin page of freenet and enter at"
	elog "Plugin-URL: /usr/share/Freemail/lib/Freemail.jar"
	elog " This should load the Freemail plugin."
	elog "Set your email client to IMAP port 3143 and SMTP port 3025 on localhost."
	elog "To bind freemail to different ports, or to a different freenet node, edit"
	elog "/var/freenet/globalconfig."
}
