# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for rubygems"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	ruby_targets_ruby24? ( >=dev-ruby/rubygems-2.6.11[ruby_targets_ruby24] )
	ruby_targets_ruby25? ( >=dev-ruby/rubygems-2.7.3[ruby_targets_ruby25] )
	ruby_targets_ruby26? ( >=dev-ruby/rubygems-3.0.1[ruby_targets_ruby26] )"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { eapply_user; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
