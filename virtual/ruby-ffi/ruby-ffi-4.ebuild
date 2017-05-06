# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for the Ruby ffi library"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	ruby_targets_ruby21? ( dev-ruby/ffi[ruby_targets_ruby21] )
	ruby_targets_ruby22? ( dev-ruby/ffi[ruby_targets_ruby22] )
	ruby_targets_ruby23? ( dev-ruby/ffi[ruby_targets_ruby23] )
	ruby_targets_ruby24? ( dev-ruby/ffi[ruby_targets_ruby24] )
"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
