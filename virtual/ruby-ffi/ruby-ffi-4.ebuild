# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for the Ruby ffi library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	ruby_targets_ruby20? ( dev-ruby/ffi[ruby_targets_ruby20] )
	ruby_targets_ruby21? ( dev-ruby/ffi[ruby_targets_ruby21] )
	ruby_targets_ruby22? ( dev-ruby/ffi[ruby_targets_ruby22] )
	ruby_targets_ruby23? ( dev-ruby/ffi[ruby_targets_ruby23] )
"
DEPEND=""

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
