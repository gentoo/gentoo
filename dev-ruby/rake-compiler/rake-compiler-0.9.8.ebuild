# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="Provide a standard and simplified way to build and package Ruby extensions"
HOMEPAGE="https://github.com/luislavena/rake-compiler"
LICENSE="MIT"

SRC_URI="https://github.com/luislavena/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/rake"

ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"

USE_RUBY="ruby20 ruby21 ruby22" ruby_add_bdepend "test? ( dev-util/cucumber )"

all_ruby_prepare() {
	# Make sure the right rspec version is used in cucumber.
	sed -i -e "1igem 'rspec', '~>2.0'" features/support/env.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby19)
			# Remove this task so that it won't load on Ruby 1.9
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
	# Skip cucumber for ruby23 (not ready yet)
	case ${RUBY} in
		*ruby20|*ruby21|*ruby22)
			ruby-ng_rspec
			ruby-ng_cucumber
			;;
		*)
			ruby-ng_rspec
			;;
	esac
}
