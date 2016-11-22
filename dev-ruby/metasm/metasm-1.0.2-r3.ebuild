# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="BUGS README TODO"

RUBY_FAKEGEM_EXTRAINSTALL="metasm metasm.rb misc samples"

inherit ruby-fakegem

DESCRIPTION="cross-architecture assembler, disassembler, linker, and debugger"
HOMEPAGE="http://metasm.cr0.org/"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
#IUSE="development test"
IUSE=""

RDEPEND="${RDEPEND} !dev-ruby/metasploit-model:0"

ruby_add_bdepend "dev-ruby/bundler"

all_ruby_prepare() {
	if [ -f Gemfile.lock ]; then
		rm  Gemfile.lock || die
	fi
	#For now, we don't support development or testing at all
	#if ! use development; then
		sed -i -e "/^group :development do/,/^end$/d" Gemfile || die
		sed -i -e "/s.add_development_dependency/d" "${PN}".gemspec || die
		sed -i -e "/spec.add_development_dependency/d" "${PN}".gemspec || die
	#fi
	#if ! use test; then
		sed -i -e "/^group :test do/,/^end$/d" Gemfile || die
	#fi
	#if ! use test && ! use development; then
		sed -i -e "/^group :development, :test do/,/^end$/d" Gemfile || die
	#fi
}

each_ruby_prepare() {
	if [ -f Gemfile ]
	then
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['tests/*.rb'].each{|f| require f}" || die
}
