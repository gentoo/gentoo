# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Displays information about ACPI devices"
HOMEPAGE="https://sourceforge.net/projects/acpiclient/"
SRC_URI="mirror://sourceforge/acpiclient/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

src_install() {
	default
	einstalldocs
}
