# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU Student's Timetable for polish users"
HOMEPAGE="https://sourceforge.net/projects/gnutu/"
SRC_URI="https://master.dl.sourceforge.net/project/gnutu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="
	>=dev-lang/mono-1.2.5.1-r1
	>=dev-dotnet/gtk-sharp-2.12.21
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

src_prepare() {
	# Remove deprecated Application tag from .desktop file
	sed -i 's/\;Application//g' gnutu.desktop.cs || die "Sed failed"
	default
}
