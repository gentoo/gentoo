# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Iconsets for Claws Mail"
HOMEPAGE="https://www.claws-mail.org/"
SRC_URI="https://www.claws-mail.org/themes/${P}.tar.gz"

LICENSE="GPL-2 GPL-3 CC-BY-3.0 CC-BY-SA-2.5 CC-BY-NC-SA-3.0 CC-BY-ND-3.0 MPL-1.1 freedist public-domain all-rights-reserved"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
RESTRICT="mirror bindist"

RDEPEND="mail-client/claws-mail"
