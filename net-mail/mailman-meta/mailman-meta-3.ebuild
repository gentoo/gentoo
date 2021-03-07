# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta ebuild for GNU Mailman 3"
HOMEPAGE="https://list.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=net-mail/mailman-3.0
	net-mail/postorius
	net-mail/hyperkitty"
