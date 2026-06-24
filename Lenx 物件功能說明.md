# GeoGebra 3D 透鏡模組
## Lens Module 2.0 — 83 個物件功能說明

---

**符號慣例：**
- `α`、`β` = 球面半徑（自變量）
- `φ` = 斯乃爾定律折射角正弦值
- `θ` = 折射／入射角
- `θ_{υ,…}` = 視覺輔助角（下標含 υ 者均為視覺輔助物件，除 `θ_{υ,3rd,Incident}` 外）
- `plzdtyA/B` = 入射側判斷布林值
- `δ` = TIR 反射次數

---

## 第一組：自變物件（8 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 1 | `A` | 點 (Point) | 球面 a 的球心，為完全自由的自變點，決定透鏡第一折射面的空間位置。 |
| 2 | `B` | 點 (Point) | 球面 b 的球心，為完全自由的自變點，決定透鏡第二折射面的空間位置。 |
| 3 | `α` | 數 (Number) | 球面 a 的半徑，自變純量，與 A 共同定義第一折射球面。 |
| 4 | `β` | 數 (Number) | 球面 b 的半徑，自變純量，與 B 共同定義第二折射球面。 |
| 5 | `Light₁` | 點 (Point) | 入射光線的起始點（光源端），為自變點。 |
| 6 | `Light₂` | 點 (Point) | 入射光線的方向參考點，與 Light₁ 共同定義入射方向。 |
| 7 | `n_Out` | 數 (Number) | 透鏡外側介質的折射率（通常設為 1，即真空／空氣）。 |
| 8 | `n_Lens` | 數 (Number) | 透鏡玻璃的折射率（例如 1.3，決定折射及全反射的臨界角）。 |

---

## 第二組：幾何基礎（6 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 9 | `a` | 球面 (Sphere) | `Sphere(A, α)`：以 A 為圓心、α 為半徑的球面，定義透鏡第一折射面（入光側或出光側，視 plzdtyA/B 而定）。 |
| 10 | `b` | 球面 (Sphere) | `Sphere(B, β)`：以 B 為圓心、β 為半徑的球面，定義透鏡第二折射面。 |
| 11 | `Lens` | 圓 (Circle) | `IntersectConic(a, b)`：球面 a 與 b 的交線，即透鏡輪廓圓，後續所有折射弧的端點均在此圓上。 |
| 12 | `IncidentRay₁` | 射線 (Ray) | `Ray(Light₁, Light₂)`：從光源射出的入射光線。 |
| 13 | `LensMidPlane` | 平面 (Plane) | `Plane(Lens)`：透鏡輪廓圓所在的平面，作為幾何計算的基準面。 |
| 14 | `LensMidPoint` | 點 (Point) | `Intersect(Segment(A,B), LensMidPlane)`：A、B 連線與 LensMidPlane 的交點，即透鏡幾何中心點。 |

---

## 第三組：入射側判斷（5 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 15 | `θ_ds` | 角 (Angle) | `Angle(Light₁, LensMidPoint, A)`：用於判斷入射光從哪一側進入透鏡（A 側或 B 側）。 |
| 16 | `plzdtyA` | 布林 (Boolean) | `θ_ds < π/2`：若為 true，表示光線從球面 b（B 側）入射，第一折射面為球面 b。 |
| 17 | `plzdtyB` | 布林 (Boolean) | `θ_ds > π/2`：若為 true，表示光線從球面 a（A 側）入射，第一折射面為球面 a。 |
| 18 | `InTFz_{1st,InRe}` | 平面 (Plane) | 包含入射光線及對應球心（B 或 A）的平面，作為第一折射點所在弧的截切平面。 |
| 19 | `f` | 直線 (Line) | `IntersectPath(InTFz_{1st,InRe}, LensMidPlane)`：截切平面與透鏡中心面的交線，用以確定第一折射弧的兩端點。 |

---

## 第四組：第一次折射（11 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 20 | `Vertex_{1st→1}` | 點 (Point) | `Intersect(f, Lens, 1)`：直線 f 與透鏡輪廓圓 Lens 的第一交點，為第一折射弧的端點之一。 |
| 21 | `Vertex_{1st→2}` | 點 (Point) | `Intersect(f, Lens, 2)`：直線 f 與透鏡輪廓圓 Lens 的第二交點，為第一折射弧的端點之二。 |
| 22 | `Arc_{1st,InRe}` | 弧 (Arc) | 第一折射面在截切平面內對應的球面弧，入射光線與此弧的交點即為第一折射點。 |
| 23 | `Incident_{1st,InRe}` | 點 (Point) | 入射光線 IncidentRay₁ 與第一折射弧的交點，即第一個折射發生位置。 |
| 24 | `Normal_{1st,InRe}` | 直線 (Line) | 過 Incident_{1st,InRe} 與對應球心（B 或 A）的法線，即球面在該點的法線。 |
| 25 | `θ_{1st,Incident}` | 角 (Angle) | `Angle(IncidentRay₁, Normal_{1st,InRe})`：入射光線與法線的夾角，即第一入射角。 |
| 26 | `φ_{1st,Refraction}` | 數 (Number) | `(n_Out / n_Lens) · sin(θ_{1st,Incident})`：依 Snell 定律計算第一折射角的正弦值。 |
| 27 | `Rotate_{1st,Refraction}` | 點 (Point) | 對應球心（B 或 A）繞 Incident_{1st,InRe} 旋轉 `-sin⁻¹(φ_{1st,Refraction})` 後的位置，用以幾何地定義折射方向。 |
| 28 | `RefractionRay₁` | 射線 (Ray) | `Ray(Incident_{1st,InRe}, Rotate_{1st,Refraction})`：第一次折射後在透鏡內部傳播的折射光線。 |
| 29 | `IncidentSegment₁` | 線段 (Segment) | `Segment(Light₁, Incident_{1st,InRe})`：從光源到第一折射點的入射段，長度供後續判斷使用。 |
| 30 | `InTFz_{2nd,InRe}` | 平面 (Plane) | 包含 RefractionRay₁ 及對應球心（A 或 B）的平面，作為第二折射截切平面。 |

---

## 第五組：第二次折射（14 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 31 | `g` | 直線 (Line) | `IntersectPath(InTFz_{2nd,InRe}, LensMidPlane)`：第二截切平面與透鏡中心面的交線，用以確定第二折射弧的端點。 |
| 32 | `Vertex_{2nd→1}` | 點 (Point) | `Intersect(g, Lens, 1)`：直線 g 與 Lens 的第一交點，第二折射弧端點之一。 |
| 33 | `Vertex_{2nd→2}` | 點 (Point) | `Intersect(g, Lens, 2)`：直線 g 與 Lens 的第二交點，第二折射弧端點之二。 |
| 34 | `Arc_{2nd,InRe}` | 弧 (Arc) | 第二折射面（第一折射面的另一側球面）在截切平面內對應的弧，RefractionRay₁ 與此弧相交。 |
| 35 | `Incident_{2nd,InRe}` | 點 (Point) | RefractionRay₁ 與 Arc_{2nd,InRe} 的交點，即第二折射／全反射發生位置。 |
| 36 | `Normal_{2nd,InRe}` | 直線 (Line) | 過 Incident_{2nd,InRe} 與對應球心（A 或 B）的法線。 |
| 37 | `IncidentSegment₂` | 線段 (Segment) | `Segment(Incident_{1st,InRe}, Incident_{2nd,InRe})`：在透鏡內部從第一到第二折射點的光程長度，用於判斷是否超出球面範圍。 |
| 38 | `θ_{2nd,Incident}` | 角 (Angle) | `Angle(RefractionRay₁, Normal_{2nd,InRe})`：第一條折射光線與第二法線的夾角，即第二入射角。 |
| 39 | `φ_{2nd,Refraction}` | 數 (Number) | `(n_Lens / n_Out) · sin(θ_{2nd,Incident})`：第二折射角的正弦值；若 ≥ 1 則觸發全反射（TIR）。 |
| 40 | `θ_{2nd,Refraction}` | 角 (Angle) | `sin⁻¹(φ_{2nd,Refraction})`：第二折射角（僅在未發生 TIR 時有意義）。 |
| 41 | `Rotate_{1st,Refraction,Reflection}` | 點 (Point) | `Reflect(Rotate_{1st,Refraction}, Incident_{2nd,InRe})`：Rotate_{1st,Refraction} 對 Incident_{2nd,InRe} 的鏡像點，用於幾何構造第二折射的方向。 |
| 42 | `Rotate_{2nd,Refraction}` | 點 (Point) | 由 Rotate_{1st,Refraction,Reflection} 繞 Incident_{2nd,InRe} 旋轉 `(sin⁻¹(φ_{2nd,Refraction}) − θ_{2nd,Incident})` 後得到的點，定義第二折射（出射）方向。 |
| 43 | `IncidentRay₂` | 射線 (Ray) | `Ray(Incident_{1st,InRe}, Incident_{2nd,InRe})`：在透鏡內傳播的光線（第一到第二折射點的連線），供視覺化使用。 |
| 44 | `TIR_{2nd,InRe}` | 布林 (Boolean) | `φ_{2nd,Refraction} ≥ 1`：判斷第二折射面是否發生全反射（Total Internal Reflection）。若為 true，啟動 TIR 計算路徑。 |

---

## 第六組：全反射（TIR）計算（11 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 45 | `δ` | 數 (Number) | TIR 全反射的反射次數，由 `ceil(…)` 計算得到；0 表示未發生 TIR，正整數表示反射次數。 |
| 46 | `TIR_{1st,InRe}` | 布林 (Boolean) | `φ_{1st,Refraction} ≥ 1`：判斷第一折射面是否發生 TIR（通常為 false，因第一次是從疏介質進入密介質）。 |
| 47 | `Crash` | 布林 (Boolean) | `plzdtyA ∧ plzdtyB`：邏輯錯誤偵測旗標，正常情況下應為 false（兩者不可同時為真）。 |
| 48 | `θ_{1st,Refraction}` | 角 (Angle) | `sin⁻¹(φ_{1st,Refraction})`：第一折射角，供後續 δ 計算使用（GeoGebra 因程式錯誤將其顯示為 Number，實際應為 Angle）。 |
| 49 | `TIR_Points` | 列表 (List) | `Sequence(Rotate(Incident_{2nd,InRe}, n·(π − 2θ_{2nd,Incident}), A/B, …), n, 0, δ)`：TIR 路徑上各個反射點的有序列表，共 δ+1 個點。 |
| 50 | `TIR_Segments` | 列表 (List) | `Sequence(Segment(TIR_Points[m], TIR_Points[m+1]), m, 1, δ−1)`：TIR 路徑上各段折線的線段列表，供視覺化顯示。 |
| 51 | `ReflectionRay_{TIR,Last}` | 射線 (Ray) | TIR 最後一次反射後的出射方向：若有 TIR，從 TIR_Points[δ] 出發射向 TIR_Points[δ+1]。 |
| 52 | `InTFz_{3rd,TIR,InRe}` | 平面 (Plane) | 包含 ReflectionRay_{TIR,Last} 及對應球心的平面，作為第三折射（TIR 後出射面）的截切平面。 |
| 53 | `h` | 直線 (Line) | `IntersectPath(InTFz_{3rd,TIR,InRe}, LensMidPlane)`：第三截切平面與透鏡中心面的交線。 |
| 54 | `Vertex_{3rd→1}` | 點 (Point) | `Intersect(h, Lens, 1)`：直線 h 與 Lens 的第一交點，第三折射弧端點之一。 |
| 55 | `Vertex_{3rd→2}` | 點 (Point) | `Intersect(h, Lens, 2)`：直線 h 與 Lens 的第二交點，第三折射弧端點之二。 |

---

## 第七組：第三次折射（TIR 後出射）（11 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 56 | `Arc_{3rd,TIR,InRe}` | 弧 (Arc) | TIR 後光線出射的球面弧，即第三折射面在截切平面內的對應弧；ReflectionRay_{TIR,Last} 與此弧相交。 |
| 57 | `Incident_{3rd,TIR,InRe}` | 點 (Point) | ReflectionRay_{TIR,Last} 與 Arc_{3rd,TIR,InRe} 的交點，即 TIR 後光線離開透鏡的折射點。 |
| 58 | `Normal_{3rd,TIR,InRe}` | 直線 (Line) | 過 Incident_{3rd,TIR,InRe} 與對應球心的法線，用於計算第三折射角。 |
| 59 | `TIR_{2nd.InRe,d}` | 布林 (Boolean) | `φ_{2nd,Refraction} < 1`：TIR_{2nd,InRe} 的補集，表示第二折射面未發生 TIR（正常出射路徑）。 |
| 60 | `Reflect_{TIR,Last}` | 點 (Point) | `Element(TIR_Points, δ)`：TIR 路徑中第 δ 個點，即 ReflectionRay_{TIR,Last} 的起始點，輔助確定第三折射方向。 |
| 61 | `θ_{υ,3rd,Incident}` | 角 (Angle) | `Angle(B/A, Incident_{3rd,TIR,InRe}, Reflect_{TIR,Last})`：第三入射角（TIR 後）；此角直接作為 φ_{3rd,Refraction} 的輸入，具有實際物理計算用途（非純視覺輔助）。 |
| 62 | `φ_{3rd,Refraction}` | 數 (Number) | `(n_Lens / n_Out) · sin(θ_{υ,3rd,Incident})`：第三折射角的正弦值，依 Snell 定律計算 TIR 後的出射折射。 |
| 63 | `θ_{3rd,Refraction}` | 角 (Angle) | `sin⁻¹(φ_{3rd,Refraction})`：第三折射角，即 TIR 後光線離開透鏡時的折射角。 |
| 64 | `Reflect_{A,B,3rd,InRe}` | 點 (Point) | 對應球心（B 或 A）對 Incident_{3rd,TIR,InRe} 的鏡像點，用於幾何構造第三折射的出射方向。 |
| 65 | `IncidentSegment₃` | 線段 (Segment) | TIR 發生時為 `Segment(TIR_Points[δ], Incident_{3rd,TIR,InRe})`；未發生時退化為 `Segment(A,B)`，作為標識。 |
| 66 | `Rotate_{3rd,Refraction}` | 點 (Point) | `Rotate(Reflect_{A,B,3rd,InRe}, sin⁻¹(φ_{3rd,Refraction}), Incident_{3rd,TIR,InRe}, InTFz_{3rd,TIR,InRe})`：第三折射出射方向的目標點。 |

---

## 第八組：視覺輔助與最終出射（10 個）

> 本組所有 `θ_{υ,…}` 物件（除已移至第七組的 `θ_{υ,3rd,Incident}` 外）均為純視覺輔助，不參與物理計算。

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 67 | `θ_{υ,1st,Refraction}` | 角 (Angle) | 視覺輔助：`Angle(B/A, Incident_{1st,InRe}, Rotate_{1st,Refraction})`，於圖形介面顯示第一折射角的視覺標記。 |
| 68 | `θ_{υ,2nd,Incident}` | 角 (Angle) | 視覺輔助：顯示第二入射角，與 θ_{2nd,Incident} 數值相同，但以視覺角物件形式呈現於圖形介面。 |
| 69 | `Αuxiliary_{A,B,for visual angles}` | 點 (Point) | 對應球心（B 或 A）對 Incident_{1st,InRe} 的鏡像點，作為視覺角度量測的輔助點，使角度物件能正確呈現折射幾何。 |
| 70 | `θ_{υ,1st,Incident}` | 角 (Angle) | 視覺輔助：`Angle(Light₁, Incident_{1st,InRe}, Αuxiliary_{…})`，於圖形介面顯示第一入射角。 |
| 71 | `θ_{υ,2nd,Refraction}` | 角 (Angle) | 視覺輔助：`Angle(Rotate_{2nd,Refraction}, Incident_{2nd,InRe}, Αuxiliary_{…})`，於圖形介面顯示第二折射角。 |
| 72 | `TIR_StandredLine` | 列表 (List) | TIR 路徑各反射點的法線列表（`Sequence(Line(A/B, TIR_Points[a]), a, 1, δ)`），供視覺化顯示法線位置。 |
| 73 | `Bd1` | 布林 (Boolean) | `IncidentSegment₂ > β`：邊界判斷旗標，當透鏡內光程超過 β 時為 true，配合 Rotate_{2nd,Refraction} 修正折射方向計算。 |
| 74 | `Bd2` | 布林 (Boolean) | `IncidentSegment₂ > α`：邊界判斷旗標，配合 Bd1 共同處理光線穿越球面邊界的特殊情形。 |
| 75 | `RefractionRay_Final` | 射線 (Ray) | **最終出射光線**：若發生 TIR（TIR_{2nd,InRe}=true），則從 Incident_{3rd,TIR,InRe} 射向 Rotate_{3rd,Refraction}；否則從 Incident_{2nd,InRe} 射向 Rotate_{2nd,Refraction}。**此為模組的核心輸出。** |
| 76 | `θ_{υ,3rd,Refraction}` | 角 (Angle) | 視覺輔助：`Angle(Reflect_{A,B,3rd,InRe}, Incident_{3rd,TIR,InRe}, Rotate_{3rd,Refraction})`，於圖形介面顯示第三折射角。 |

---

## 第九組：透鏡視覺化與輸出截面（7 個）

| # | 物件名稱 | 型別 | 功能說明 |
|---|----------|------|----------|
| 77 | `MirrowLength` | 線段 (Segment) | `Segment(球面 a 在 AB 連線上的交點, 球面 b 在 AB 連線上的交點)`：透鏡在光軸（AB 連線）上的有效長度，供透鏡表面渲染使用。 |
| 78 | `u` | 向量 (Vector) | 透鏡表面渲染的切向單位向量之一：`UnitVector(AB) × UnitVector(Plane(A,B,Light₁))`，定義透鏡曲面的環向參數化方向。 |
| 79 | `v` | 向量 (Vector) | 透鏡表面渲染的切向單位向量之二：`UnitVector(AB) × u`，與 u 正交，共同定義曲面的參數化座標系。 |
| 80 | `SurfaceA` | 曲面 (Surface) | 球面 a 在透鏡有效區域（從 LensMidPoint 到 a 在 AB 上的交點）內的 3D 曲面，用於渲染透鏡第一折射面的幾何外觀。 |
| 81 | `SurfaceB` | 曲面 (Surface) | 球面 b 在透鏡有效區域（從 LensMidPoint 到 b 在 AB 上的交點）內的 3D 曲面，用於渲染透鏡第二折射面的幾何外觀。 |
| 82 | `eq1` | 平面 (Plane) | 輸出截面平面（使用者自訂的觀察面），用於截取 RefractionRay_Final 並計算最終光線的落點位置。 |
| 83 | `C` | 點 (Point) | `Intersect(RefractionRay_Final, eq1)`：最終出射光線與觀察截面 eq1 的交點，代表透鏡模組的最終輸出——偏折光線在觀察面上的成像位置。 |
