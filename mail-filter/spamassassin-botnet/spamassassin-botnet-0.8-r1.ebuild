# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

MY_PN="${PN/b/B}"
MY_PN="${MY_PN/spamassassin-/}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="SpamAssassin plugin that attempts to detect messages sent by a botnet"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://people.ucsc.edu/~jrudd/spamassassin/${MY_P}.tar"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=mail-filter/spamassassin-3.0.0"
RDEPEND="${DEPEND}"

src_compile() {
	# make sure it doesn't try to look for the .pm in the same dir as the .cf
	sed -rie 's/^(loadplugin.+)[ ]+Botnet.pm/\1/' Botnet.cf || die
}

src_install() {
	perl_set_version

	local plugin_dir=${VENDOR_LIB}/Mail/SpamAssassin/Plugin

	insinto ${plugin_dir}
	doins ${MY_PN}.pm

	insinto /etc/mail/spamassassin/
	doins ${MY_PN}.cf

	dodoc ${MY_PN}{{.{api,credits,variants},}.txt,.pl}
}

pkg_postinst() {
	echo
	elog "You need to restart spamassassin (as root) before this plugin will work:"
	elog "/etc/init.d/spamd restart"
	echo
}
