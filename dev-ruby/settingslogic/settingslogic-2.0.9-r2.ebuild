# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A simple configuration / settings solution that uses an ERB enabled YAML file"
HOMEPAGE="https://github.com/binarylogic/settingslogic"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-psych-4.patch" )

all_ruby_prepare() {
	sed -i -e '/check_dependencies/d' Rakefile || die

	# Use rspec 3
	sed -i -e 's/be_false/be false/' spec/settingslogic_spec.rb || die
}
