# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"
RUBY_FAKEGEM_GEMSPEC="openfact.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="OpenFact, a system inventory tool (community implementation of Facter)"
HOMEPAGE="https://github.com/OpenVoxProject/openfact"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenVoxProject/openfact.git"
	EGIT_BRANCH="main"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="https://github.com/OpenVoxProject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

ruby_add_rdepend "
	dev-ruby/ffi
	dev-ruby/hocon
	dev-ruby/sys-filesystem
	<dev-ruby/thor-2.0
"

ruby_add_bdepend "test? ( dev-ruby/webmock )"

RDEPEND+="
	!dev-ruby/facter
	!app-admin/puppet-agent
"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Breaks tests; handle deps ourselves
	sed -e "/require 'bundler/d" -i spec/spec_helper.rb || die

	# dev tasks not needed, but block tests
	for f in tasks/rubocop.rake tasks/check.rake ; do
		test -e ${f} && mv -f ${f}{,.DISABLE}
	done

	# Avoid dependency on simplecov
	sed -e '/simplecov/,/^end/ s:^:#:' \
		-e '/SimpleCov/ s:^:#:' \
		-i spec/spec_helper.rb || die
}
