# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="Provide a standard and simplified way to build and package Ruby extensions"
HOMEPAGE="http://github.com/luislavena/rake-compiler"
LICENSE="MIT"

SRC_URI="http://github.com/luislavena/${PN}/tarball/v${PV} -> ${P}.tar.gz"
RUBY_S="luislavena-${PN}-*"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/rake"
USE_RUBY="ruby19 ruby20" ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"
USE_RUBY="ruby19" ruby_add_bdepend "test? ( dev-util/cucumber )"

each_ruby_prepare() {
	case ${RUBY} in
		*ruby19|*jruby)
			# Remove this task so that it won't load on Ruby 1.9 and JRuby
			# that lack the package_task file. It is, though, needed for the
			# tests
			rm tasks/gem.rake || die
			# Remove specs aimed at a C-compiling ruby implementation.
			rm spec/lib/rake/extensiontask_spec.rb || die
			;;
		*)
			;;
	esac
}

each_ruby_test() {
	# Skip cucumber for jruby (not supported) and ruby20 (not ready yet)
	# Skip rspec as well for ruby21 to allow bootstrapping rspec for ruby21
	case ${RUBY} in
		*ruby19)
			ruby-ng_rspec
			ruby-ng_cucumber
			;;
		*ruby21)
			;;
		*)
			ruby-ng_rspec
			;;
	esac
}
