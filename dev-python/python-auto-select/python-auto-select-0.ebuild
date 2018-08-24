# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )

inherit python-r1

DESCRIPTION="Automatically selects a python interpreter based on enabled targets"
HOMEPAGE="https://gentoo.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	app-eselect/eselect-python
"

echoit() {
	echo "$@"
	"$@"
}

pkg_setup() {
	# Clean up first
	echoit eselect python cleanup || die

	local python=$(eselect python show)
	local python2=$(eselect python show --python2)
	local python3=$(eselect python show --python3)

	local python_best= python2_best= python3_best=
	local python_ok= python2_ok= python3_ok=

	_check_python() {
		python_best=${EPYTHON}
		if [[ ${python} == ${EPYTHON} ]]; then
			python_ok=true
		fi
		if python_is_python3; then
			python3_best=${EPYTHON}
			if [[ ${python3} == ${EPYTHON} ]]; then
				python3_ok=true
			fi
		else
			python2_best=${EPYTHON}
			if [[ ${python2} == ${EPYTHON} ]]; then
				python2_ok=true
			fi
		fi
	}

	python_foreach_impl _check_python

	if [[ ! ${python_ok} && -n ${python_best} ]]; then
		echoit eselect python set "${python_best}" || die
	fi
	if [[ ! ${python2_ok} && -n ${python2_best} ]]; then
		echoit eselect python set --python2 "${python2_best}" || die
	fi
	if [[ ! ${python3_ok} && -n ${python3_best} ]]; then
		echoit eselect python set --python3 "${python3_best}" || die
	fi
}
