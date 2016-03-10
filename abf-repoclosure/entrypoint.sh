#!/bin/bash
pushd /repoclosure-report
urpm-repoclosure -profile /tmp/profile.xml
popd
