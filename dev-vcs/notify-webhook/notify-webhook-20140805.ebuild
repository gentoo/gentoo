# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/notify-webhook/notify-webhook-20140805.ebuild,v 1.1 2015/03/09 00:51:59 robbat2 Exp $

EAPI=5

DESCRIPTION="Git post-receive web hook notifier in Python."
HOMEPAGE="https://github.com/metajack/notify-webhook"
COMMIT='c571160f155122446e97bb01c1150b4d14ea69d6'
SRC_URI="https://github.com/metajack/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/simplejson"
RDEPEND="${DEPEND}"

MY_P="${PN}-${COMMIT}"
S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc *markdown
	exeinto /usr/libexec/githook/$PN/
	doexe notify-webhook.py
}
