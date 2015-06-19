# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/ntlmaps/ntlmaps-0.9.9.6-r3.ebuild,v 1.2 2015/03/21 20:34:29 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib systemd user python-r1

DESCRIPTION="NTLM proxy Authentication against MS proxy/web server"
HOMEPAGE="http://ntlmaps.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ntlmaps
	enewuser ntlmaps -1 -1 -1 ntlmaps
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"

	sed \
		-e 's/\r//' \
		-i lib/*.py server.cfg doc/*.{txt,htm} || die 'Failed to convert line endings.'
}

src_install() {
	# Bug #351305, prevent file collision.
	rm "${S}"/lib/utils.py || die

	python_foreach_impl python_domodule lib/*.py

	python_foreach_impl python_newscript main.py ntlmaps

	python_foreach_impl python_optimize

	dodoc doc/*.txt
	dohtml doc/*.{gif,htm}

	insopts -m0640 -g ntlmaps
	insinto /etc/ntlmaps
	doins server.cfg
	newinitd "${FILESDIR}/ntlmaps.init" ntlmaps
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -m 0770 -g ntlmaps
	keepdir /var/log/ntlmaps
}
