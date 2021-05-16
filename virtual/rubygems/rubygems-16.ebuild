# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for rubygems"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	ruby_targets_ruby25? ( >=dev-ruby/rubygems-2.7.3[ruby_targets_ruby25] )
	ruby_targets_ruby26? ( >=dev-ruby/rubygems-3.0.1[ruby_targets_ruby26] )
	ruby_targets_ruby27? ( >=dev-ruby/rubygems-3.1.0[ruby_targets_ruby27] )
	ruby_targets_ruby30? ( >=dev-ruby/rubygems-3.2.0[ruby_targets_ruby30] )
"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { eapply_user; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
