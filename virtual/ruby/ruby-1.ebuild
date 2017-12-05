# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22 rbx"

inherit ruby-single

DESCRIPTION="Virtual ebuild for ruby"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="${RUBY_DEPS}"

# The purpose of this ebuild is to provide a mechanism for end-users to
# install the "best" ruby version on their system, based on current
# stable versions and default RUBY_TARGETS. Other ebuilds should not
# depend on this but instead use the ruby-single eclass.
