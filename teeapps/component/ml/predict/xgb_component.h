// Copyright 2023 Ant Group Co., Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once

#include "../../component.h"

namespace teeapps {
namespace component {

class XgbPredComponent : public Component {
 private:
  void Init();

  explicit XgbPredComponent(
      const std::string& name = "xgb_predict",
      const std::string& domain = "ml.predict",
      const std::string& version = "0.0.1",
      const std::string& desc = "Predict using the XGB model.")
      : Component(name, domain, version, desc) {
    Init();
  }
  ~XgbPredComponent() {}
  XgbPredComponent(const XgbPredComponent&) = delete;
  const XgbPredComponent& operator=(const XgbPredComponent&) = delete;

 public:
  static XgbPredComponent& GetInstance() {
    static XgbPredComponent instance;
    return instance;
  }
};

}  // namespace component
}  // namespace teeapps
