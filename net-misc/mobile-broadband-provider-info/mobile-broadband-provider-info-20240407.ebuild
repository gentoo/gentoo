# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="Database of mobile broadband service providers"
HOMEPAGE="https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info"

LICENSE="CC-PD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-libs/libxslt
	test? ( dev-libs/libxml2 )
"

DOCS=( README )
