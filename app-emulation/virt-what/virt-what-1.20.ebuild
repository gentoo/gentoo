# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Detects if the current machine is running in a virtual machine"
HOMEPAGE="https://people.redhat.com/~rjones/virt-what/"
SRC_URI="https://people.redhat.com/~rjones/virt-what/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="dmi"

DEPEND="dev-lang/perl"
RDEPEND="app-shells/bash
	dmi? ( sys-apps/dmidecode )"

src_prepare() {
	default

	# Pretends to be POSIX sh while it is not
	sed -e 's:/bin/sh:/bin/bash:' -i virt-what.in || die
}
