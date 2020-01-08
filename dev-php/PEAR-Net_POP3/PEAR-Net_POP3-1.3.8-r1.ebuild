# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides a POP3 class to access POP3 server"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 ~sparc x86"
IUSE="+sasl"
RDEPEND=">=dev-php/PEAR-Net_Socket-1.0.6-r1
	sasl? ( >=dev-php/PEAR-Auth_SASL-1.0.2 )"
HTML_DOCS=( docs/examples/Net_POP3_example.php )
