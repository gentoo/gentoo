# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for rubygems"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	ruby_targets_ruby32? ( >=dev-ruby/rubygems-3.4.19[ruby_targets_ruby32] )
	ruby_targets_ruby33? ( >=dev-ruby/rubygems-3.5.22[ruby_targets_ruby33] )
	ruby_targets_ruby34? ( >=dev-ruby/rubygems-3.6.2[ruby_targets_ruby34] )
	ruby_targets_ruby40? ( >=dev-ruby/rubygems-4.0.3[ruby_targets_ruby40] )
"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { eapply_user; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
