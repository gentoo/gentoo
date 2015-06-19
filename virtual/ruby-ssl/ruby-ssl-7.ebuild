# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ruby-ssl/ruby-ssl-7.ebuild,v 1.1 2015/01/19 19:51:01 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for the Ruby OpenSSL bindings"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	ruby_targets_ruby19? ( dev-lang/ruby:1.9[ssl] )
	ruby_targets_ruby20? ( dev-lang/ruby:2.0[ssl] )
	ruby_targets_ruby21? ( dev-lang/ruby:2.1[ssl] )
	ruby_targets_ruby22? ( dev-lang/ruby:2.2[ssl] )"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
