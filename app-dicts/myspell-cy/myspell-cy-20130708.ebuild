# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"cy_GB.aff"
	"cy_GB.dic"
)

inherit myspell-r2

DESCRIPTION="Welsh dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.openoffice.org/en/project/gwirydd-sillafu-cymraeg-welsh-language-spell-checker"
SRC_URI="mirror://sourceforge/aoo-extensions/geiriadur-cy.oxt -> ${P}.oxt"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
