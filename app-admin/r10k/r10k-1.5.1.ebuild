# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Puppet environment and module deployment"
HOMEPAGE="https://github.com/adrienthebo/r10k"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+git"

ruby_add_rdepend "
	>=dev-ruby/colored-1.2
	=dev-ruby/cri-2.7*
	>=dev-ruby/systemu-2.5.2
	>=dev-ruby/log4r-1.1.10
	>=dev-ruby/faraday-0.9.0
	>=dev-ruby/faraday_middleware-0.9.0
	>=dev-ruby/faraday_middleware-multi_json-0.0.6
	>=dev-ruby/multi_json-1.10
	>=dev-ruby/semantic_puppet-0.1.1
	dev-ruby/json"

RDEPEND="${RDEPEND} git? ( >=dev-vcs/git-1.6.6 )"

all_ruby_prepare() {
	sed -i -e 's/json_pure/json/' \
		-e '/cri/ s/2\.6\../2.7/' \
		-e '/systemu/ s/2.5.2/2.5/' \
		-e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

pkg_postinst() {
	ewarn
	ewarn "If you are upgrading from 1.1.0 and are using multiple sources, please read"
	ewarn "this. (If not, feel free to continue with your regularly scheduled day.)"
	ewarn
	ewarn "GH-48 (https://github.com/adrienthebo/r10k/issues/48) introduced the ability"
	ewarn "for environments to be prefixed with the source name so that multiple sources"
	ewarn "installed into the same directory would not overwrite each other. However"
	ewarn "prefixing was automatically enabled and would break existing setups where"
	ewarn "multiple sources were cloned into different directories."
	ewarn
	ewarn "Because this introduced a breaking change, SemVer dictates that the automatic"
	ewarn "prefixing has to be rolled back. Prefixing can be enabled but always defaults"
	ewarn "to off. If you are relying on this behavior you will need to update your r10k.yaml"
	ewarn "to enable prefixing on a per-source basis."
	ewarn
	ewarn "Please see the issue (https://github.com/adrienthebo/r10k/issues/48) for more"
	ewarn "information."
}
