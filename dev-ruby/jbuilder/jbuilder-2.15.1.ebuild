# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_TEST="CI=true test"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Create JSON structures via a Builder-style DSL"
HOMEPAGE="https://github.com/rails/jbuilder"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"

SUPPORTED_RAILS=( 8.1 8.0 7.2 )
RAILS_DEPENDENCIES="dev-ruby/activesupport dev-ruby/actionview"
RAILS_TEST_DEPENDENCIES="${RAILS_DEPENDENCIES} dev-ruby/rails"

rails_dep() {
	local deps="${1}"
	local rails dep
	dep_string="|| ( "
	for rails in ${SUPPORTED_RAILS[@]}; do
		dep_string+=" ("
		for dep in ${deps}; do
			dep_string+=" ${dep}:${rails}"
		done
		dep_string+=" )"
	done
	dep_string+=" )"
	echo "${dep_string}"
}
ruby_add_rdepend "$(rails_dep "${RAILS_DEPENDENCIES}")"
ruby_add_bdepend "test? ( $(rails_dep "${RAILS_TEST_DEPENDENCIES}") )"
unset rails_dep

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/mocha:*
)"

all_ruby_prepare() {
	# avoid appraisal dependency
	sed -e '/appraisal/ s:^:#:' \
		-i Gemfile gemfiles/*.gemfile || die
}

each_ruby_test() {
	rails_satisfied_deps() {
		local rails="${1}"
		local found=0
		local dep
		for dep in ${RAILS_TEST_DEPENDENCIES}; do
			if ! has_version -b "${dep}:${rails}"; then
				found=1
				break
			fi
		done
		return ${found}
	}
	local rails
	for rails in ${SUPPORTED_RAILS[@]}; do
		if rails_satisfied_deps ${rails}; then
			einfo "Testing rails ${rails} with ${RUBY}"
			BUNDLE_GEMFILE="gemfiles/rails_${rails/./_}.gemfile" each_fakegem_test
		fi
	done
}
