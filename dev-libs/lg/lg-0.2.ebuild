# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small library for SBC's (such as Raspberry Pi) control of GPIO"

HOMEPAGE="http://abyz.me.uk/lg/"

SRC_URI="https://github.com/joan2937/lg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"

SLOT="0"

# for SBC's (such as Raspberry Pi)
KEYWORDS="~arm ~arm64"
