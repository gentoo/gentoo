# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=1.997
DIST_AUTHOR=CORLISS
DIST_EXAMPLES=("test.pl")
inherit perl-module

DESCRIPTION="Provide high level APIs for rapid user interface design on the console in Perl"
HOMEPAGE="http://www.digitalmages.com/perl/CursesWidgets/index.html ${HOMEPAGE}"
SRC_URI+=" http://www.digitalmages.com/perl/CursesWidgets/downloads/${PN}-${DIST_VERSION}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc ~s390 ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5
	>=dev-perl/Curses-1.60.0"
DEPEND="${RDEPEND}"

src_test() {
	local MODULES=(
		"Curses::Widgets ${DIST_VERSION}"
		"Curses::Widgets::ButtonSet 1.103"
		"Curses::Widgets::Calendar 1.103"
		"Curses::Widgets::ComboBox 1.103"
		"Curses::Widgets::Label 1.102"
		"Curses::Widgets::ListBox 1.104"
		"Curses::Widgets::ListBox::MultiColumn 0.1"
		"Curses::Widgets::Menu 1.103"
		"Curses::Widgets::ProgressBar 1.103"
		"Curses::Widgets::TextField 1.103"
		"Curses::Widgets::TextMemo 1.104"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	ewarn "Test suite for this module requires user interaction."
	ewarn "For details, see:"
	ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/CursesWidgets"
}
