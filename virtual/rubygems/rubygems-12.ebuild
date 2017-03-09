# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23 ruby24 rbx"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for rubygems"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	ruby_targets_rbx? ( dev-lang/rubinius )
	ruby_targets_ruby20? ( >=dev-ruby/rubygems-2.0.2[ruby_targets_ruby20] )
	ruby_targets_ruby21? ( >=dev-ruby/rubygems-2.0.14[ruby_targets_ruby21] )
	ruby_targets_ruby22? ( >=dev-ruby/rubygems-2.4.2[ruby_targets_ruby22] )
	ruby_targets_ruby23? ( >=dev-ruby/rubygems-2.5.1[ruby_targets_ruby23] )
	ruby_targets_ruby24? ( >=dev-ruby/rubygems-2.6.8[ruby_targets_ruby24] )"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
